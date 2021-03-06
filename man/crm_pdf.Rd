% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/crm_pdf.R
\name{crm_pdf}
\alias{crm_pdf}
\title{Get full text PDFs}
\usage{
crm_pdf(url, overwrite = TRUE, read = TRUE, overwrite_unspecified = FALSE, ...)
}
\arguments{
\item{url}{A URL (character) or an object of class \code{tdmurl} from a call
to \code{\link[=crm_links]{crm_links()}}. If you'll be getting text from the publishers are use
Crossref TDM (which requires authentication), we strongly recommend
using \code{\link[=crm_links]{crm_links()}} first and passing output of that here, as \code{\link[=crm_links]{crm_links()}}
grabs the publisher Crossref member ID, which we use to do authentication
and other publisher specific fixes to URLs}

\item{overwrite}{(logical) Overwrite file if it exists already?
Default: \code{TRUE}}

\item{read}{(logical) If reading a pdf, this toggles whether we extract
text from the pdf or simply download. If \code{TRUE}, you get the text from
the pdf back. If \code{FALSE}, you only get back the metadata.
Default: \code{TRUE}}

\item{overwrite_unspecified}{(logical) Sometimes the crossref API returns
mime type 'unspecified' for the full text links (for some Wiley dois
for example). This parameter overrides the mime type to be \code{type}.}

\item{...}{Named curl options passed on to \link[crul:verb-GET]{crul::verb-GET}, see
\code{curl::curl_options()} for available curl options. See especially the
User-agent section below}
}
\description{
Get full text PDFs
}
\section{Notes}{

Note that this function is not vectorized. To do many requests
use a for/while loop or lapply family calls, or similar.

Note that some links returned will not in fact lead you to full text
content as you would understandbly think and expect. That is, if you
use the \code{filter} parameter with e.g., \code{\link[rcrossref:cr_works]{rcrossref::cr_works()}}
and filter to only full text content, some links may actually give back
only metadata for an article. Elsevier is perhaps the worst offender,
for one because they have a lot of entries in Crossref TDM, but most
of the links that are apparently full text are not in facct full text,
but only metadata.

Check out \link{auth} for details on authentication.
}

\section{User-agent}{

You can optionally set a user agent string with the curl option \code{useragent},
like \code{crm_text("some doi", "pdf", useragent = "foo bar")}.
user agent strings are sometimes used by servers to decide whether to
provide a response (in this case, the full text article). sometimes, a
browser like user agent string will make the server happy. by default all
requests in this package have a user agent string like
\verb{libcurl/7.64.1 r-curl/4.3 crul/0.9.0}, which is a string with the names
and versions of the http clients used under the hood. If you supply
a user agent string using the \code{useragent} curl option, we'll use it instead.
For more information on user agent's, and exmaples of user agent strings you
can use here, see
https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent
}

\section{Elsevier-partial}{

For at least some PDFs from Elsevier, most likely when you do not have
full access to the full text, they will return a successful response,
but only return the first page of the PDF. They do however include
a warning message in the response headers, which we look for and pass
on to the user AND delete the pdf because we assume if you are using this
package you don't want just the first page but the whole article. This
behavior as far as we know does not occur with other article types
(xml, plain), but let us know if you see it.
}

\section{Caching}{

By default we use
\code{paste0(rappdirs::user_cache_dir(), "/crminer")}, but you can
set this directory to something different. Paths are setup under "/crminer"
for each of the file types: "/crminer/pdf", "/crminer/xml", "/crminer/txt",
and "/crminer/html". See \link{crm_cache} for caching details.

We cache all file types, as well as the extracted text from the pdf. The
text is saved in a text file with the same file name as the pdf, but with
the file extension ".txt". On subsequent requests of the same DOI, we first
look for a cached .txt file matching the DOI, and return it if it exists.
If it does not exist, but the the PDF does exist, we skip the PDF
download step and move on to reading the PDF to text; we cache that text
in to .txt file. If there's no .txt or .pdf file, we download the PDF and
read the pdf to text, and both are cached.
}

\examples{
\dontrun{
# set a temp dir. cache path
crm_cache$cache_path_set(path = "crminer", type = "tempdir")
## you can set the entire path directly via the `full_path` arg
## like crm_cache$cache_path_set(full_path = "your/path")

## peerj
x <- crm_pdf("https://peerj.com/articles/6840.pdf")

## pensoft
data(dois_pensoft)
(links <- crm_links(dois_pensoft[10], "all"))
crm_pdf(links)

## hindawi
data(dois_pensoft)
(links <- crm_links(dois_pensoft[12], "all"))
### pdf
crm_pdf(links, read=FALSE)
crm_pdf(links)
}
}
