class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "https://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.22.2/geoserver-2.22.2-bin.zip"
  sha256 "bac56a8d75e3302bdb8c4cfa4cacfb44ce40da8515af28ec8c504351fb507112"
  license "GPL-2.0-or-later"

  # GeoServer releases contain a large number of files for each version, so the
  # SourceForge RSS feed may only contain the most recent version (which may
  # have a different major/minor version than the latest stable). We check the
  # "GeoServer" directory page instead, since this is reliable.
  livecheck do
    url "https://sourceforge.net/projects/geoserver/files/GeoServer/"
    regex(%r{href=(?:["']|.*?GeoServer/)?v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e8b5d05f9d84d86937b7e6437c47c1a746e52878bba4f498fe95fc239de5ce3"
  end

  def install
    libexec.install Dir["*"]
    (bin/"geoserver").write <<~EOS
      #!/bin/sh
      if [ -z "$1" ]; then
        echo "Usage: $ geoserver path/to/data/dir"
      else
        cd "#{libexec}" && java -DGEOSERVER_DATA_DIR=$1 -jar start.jar
      fi
    EOS
  end

  def caveats
    <<~EOS
      To start geoserver:
        geoserver path/to/data/dir
    EOS
  end

  test do
    assert_match "geoserver path", shell_output("#{bin}/geoserver")
  end
end