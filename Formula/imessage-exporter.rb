class ImessageExporter < Formula
  desc "Export MacOS iMessage data + run iMessage Diagnostics"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://ghproxy.com/https://github.com/ReagentX/imessage-exporter/releases/download/1.2.0/imessage-exporter-x86_64-apple-darwin.tar.gz"
  sha256 "d2285ab43183b67b29eebb84d39dd0af68642ee77c6ef5f60cb014eeff88c3be"

  def install
    bin.install Dir["*"]
  end
end