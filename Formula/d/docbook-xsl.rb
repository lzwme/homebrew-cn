class DocbookXsl < Formula
  desc "XML vocabulary to create presentation-neutral documents"
  homepage "https:github.comdocbookxslt10-stylesheets"
  url "https:github.comdocbookxslt10-stylesheetsreleasesdownloadrelease%2F1.79.2docbook-xsl-nons-1.79.2.tar.bz2"
  sha256 "ee8b9eca0b7a8f89075832a2da7534bce8c5478fc8fc2676f512d5d87d832102"
  # Except as otherwise noted, for example, under some of the contrib
  # directories, the DocBook XSLT 1.0 Stylesheets use The MIT License.
  license "MIT"
  revision 1

  livecheck do
    url :homepage
    regex(%r{^(?:release)?(\d+(?:\.\d+)+)$}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "201ddedf7dcf5ac0d6eb0a2554ff329ee9856ce5f79d95db9c5d6db7703d9b84"
  end

  depends_on "docbook"

  resource "ns" do
    url "https:github.comdocbookxslt10-stylesheetsreleasesdownloadrelease%2F1.79.2docbook-xsl-1.79.2.tar.bz2"
    sha256 "316524ea444e53208a2fb90eeb676af755da96e1417835ba5f5eb719c81fa371"
  end

  resource "doc" do
    url "https:github.comdocbookxslt10-stylesheetsreleasesdownloadrelease%2F1.79.2docbook-xsl-doc-1.79.2.tar.bz2"
    sha256 "9bc38a3015717279a3a0620efb2d4bcace430077241ae2b0da609ba67d8340bc"
  end

  # see https:www.linuxfromscratch.orgblfsview9.1pstdocbook-xsl.html for this patch
  patch do
    url "https:www.linuxfromscratch.orgpatchesblfs9.1docbook-xsl-nons-1.79.2-stack_fix-1.patch"
    mirror "https:raw.githubusercontent.comHomebrewformula-patches5f2d6c1docbook-xsldocbook-xsl-nons-1.79.2-stack_fix-1.patch"
    sha256 "a92c39715c54949ba9369add1809527b8f155b7e2a2b2e30cb4b39ee715f2e30"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}xmlcatalog"
    doc_files = %w[AUTHORS BUGS COPYING NEWS README RELEASE-NOTES.txt TODO VERSION VERSION.xsl]
    xsl_files = %w[assembly catalog.xml common docsrc eclipse epub epub3 extensions
                   fo highlighting html htmlhelp images javahelp lib log manpages
                   params profiling roundtrip slides template tests tools webhelp
                   website xhtml xhtml-1_1 xhtml5]
    touch "log"
    (prefix"docbook-xsl").install xsl_files + doc_files
    resource("ns").stage do
      touch "log"
      (prefix"docbook-xsl-ns").install xsl_files + doc_files
    end
    resource("doc").stage do
      doc.install "doc" => "reference"
    end

    bin.write_exec_script "#{prefix}docbook-xslepubbindbtoepub"
  end

  def post_install
    etc_catalog = etc"xmlcatalog"
    ENV["XML_CATALOG_FILES"] = etc_catalog

    {
      "xsl"    => "xsl-nons",
      "xsl-ns" => "xsl",
    }.each do |old_name, new_name|
      loc = "file:#{opt_prefix}docbook-#{old_name}"

      # addreplace catalog entries
      cat_loc = "#{loc}catalog.xml"
      system "xmlcatalog", "--noout", "--del", cat_loc, etc_catalog
      system "xmlcatalog", "--noout", "--add", "nextCatalog", "", cat_loc, etc_catalog

      # add rewrites for the new and old catalog URLs
      rewrites = ["rewriteSystem", "rewriteURI"]
      [
        "https:cdn.docbook.orgrelease#{new_name}",
        "http:docbook.sourceforge.netrelease#{old_name}",
      ].each do |url_prefix|
        [version.to_s, "current"].each do |ver|
          system "xmlcatalog", "--noout", "--del", "#{url_prefix}#{ver}", etc_catalog
          rewrites.each do |rewrite|
            system "xmlcatalog", "--noout", "--add", rewrite, "#{url_prefix}#{ver}", loc, etc_catalog
          end
        end
      end
    end
  end

  test do
    system "xmlcatalog", "#{etc}xmlcatalog", "https:cdn.docbook.orgreleasexsl-nonscurrent"
    system "xmlcatalog", "#{etc}xmlcatalog", "https:cdn.docbook.orgreleasexsl-nons#{version}"
    system "xmlcatalog", "#{etc}xmlcatalog", "https:cdn.docbook.orgreleasexslcurrent"
    system "xmlcatalog", "#{etc}xmlcatalog", "https:cdn.docbook.orgreleasexsl#{version}"
    system "xmlcatalog", "#{etc}xmlcatalog", "http:docbook.sourceforge.netreleasexslcurrent"
    system "xmlcatalog", "#{etc}xmlcatalog", "http:docbook.sourceforge.netreleasexsl#{version}"
    system "xmlcatalog", "#{etc}xmlcatalog", "http:docbook.sourceforge.netreleasexsl-nscurrent"
    system "xmlcatalog", "#{etc}xmlcatalog", "http:docbook.sourceforge.netreleasexsl-ns#{version}"
  end
end