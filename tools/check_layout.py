#!/usr/bin/env python3
import sys, re, pathlib

HEADER_KEYS = ['Procedure:', 'Kind:', 'Purpose:', 'Ticket:', 'Author:', 'Version:', 'CreatedOn:']
COMMON_SECTIONS = ['[Validation]', '[Permission Checks]', '[Business Rules]', '[Error Handling]', '[Output]']
DML_SECTION = '[DML & Transactions]'
KIND_RE = re.compile(r'Kind:\s*(\w+)', re.IGNORECASE)

def check_file(path):
    text = path.read_text(encoding='utf-8')
    errors = []
    for key in HEADER_KEYS:
        if key not in text:
            errors.append(f'Missing header key: {key}')
    m = KIND_RE.search(text)
    kind = m.group(1).upper() if m else None
    if not kind:
        errors.append('Missing Kind in header')
        return errors
    for sec in COMMON_SECTIONS:
        if sec not in text:
            errors.append(f'Missing section: {sec}')
    if kind in {'INSERT','UPDATE','DELETE'} and DML_SECTION not in text:
        errors.append(f'Missing section: {DML_SECTION}')
    if '@o_success_code' not in text or 'OUTPUT' not in text:
        errors.append('Missing @o_success_code INT OUTPUT')
    if '@o_message' not in text or 'OUTPUT' not in text:
        errors.append('Missing @o_message NVARCHAR(...) OUTPUT')
    if kind == 'RETRIEVE' and '@p_lang' not in text:
        errors.append('RETRIEVE must include @p_lang NVARCHAR(...)')
    return errors

def main():
    base = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else 'procedures')
    failures = 0
    for file in base.rglob('*.sql'):
        errs = check_file(file)
        if errs:
            print(f'✗ {file}')
            for e in errs:
                print(f'  - {e}')
            failures += 1
        else:
            print(f'✓ {file}')
    sys.exit(1 if failures else 0)

if __name__ == '__main__':
    main()
