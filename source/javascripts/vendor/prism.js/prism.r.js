/** Amy Chan
 * 27-05-2013
 * New tokens you need to define in CSS: .token.(slot|namespace|function|variable)
 * From `?Quotes`:
 *  Identifiers consist of a sequence of letters, digits, the period
 *   (â€˜.â€™) and the underscore.  They must not start with a digit nor
 *   underscore, nor with a period followed by a digit.  Reserved words
 *   are not valid identifiers
 */
Prism.languages.r = {
    'comment': /#.*$/gm,
    'string': /("|')(?:\\.|(?!\\|\1)[\s\S])*\1/g,
    'keyword': /\b(?:if|else|repeat|while|function|for|in|next|break)\b/g,
    // NULL etc are not really booleans but I just group them tohere to be marked up
    'boolean': /\b(?:TRUE|FALSE|T|F|NA(?:_(?:integer|real|complex|character)_)?|NULL)\b/g,
    'function': /(?:(?:[a-zA-Z]|\.(?![0-9]))[.\w]*|`[^`\s]*`)[ \t]*(?=\()/g,
    'number': /\b[-+]?(0x[\dA-Fa-f]+|\d*\.?\d+([Ee]-?\d+)?i?|Inf|NaN)\b/g,
    'operator': /(?:<|&lt;)-|[-+\/!\^]|={1,2}|(?:&[lg]t;|[><])=?|(&amp;|&){1,2}|\|\|?|\*\*?|\%(\/|in)?\%/g,
    'property': {
        pattern: /([$@])[\w._]+/g,
        lookbehind: true
    },
    'punctuation': /[@?${}[\];(),.:]/g, // Prism.Languages.clike.punctuation
    'namespace': /[\w._]+(?=::)/g,
    'variable': /(?:(?:[a-zA-Z]|\.(?![0-9]))[.\w]*|`[^`\s]*`)/g
};
