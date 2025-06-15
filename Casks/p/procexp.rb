cask "procexp" do
  version "1.0.0"
  sha256 :no_check

  url "https://newosxbook.com/tools/procexp.tgz"
  name "Process Explorer"
  homepage "https://www.newosxbook.com/tools/procexp.html"

  livecheck do
    url :homepage
    regex(/v(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  binary "procexp.universal", target: "procexp"
  manpage "procexp.1"

  # No zap stanza required
end