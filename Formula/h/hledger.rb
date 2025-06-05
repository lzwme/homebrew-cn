class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https:hledger.org"
  url "https:github.comsimonmichaelhledgerarchiverefstags1.43.1.tar.gz"
  sha256 "bd0f19601ae2c603dfeae035fd606211a2801868cfb264a37188317202b11e62"
  license "GPL-3.0-or-later"
  head "https:github.comsimonmichaelhledger.git", branch: "master"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https:hledger.orginstall.html"
    regex(%r{href=.*?tag(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4974d1fdd58b0f1adf8b59c602774725ac5248b4bc993093b3d2f7bf1ab3d1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee07664bfb270a4228f7eeee79571c6f3e24f746a3fdb208ed90506c23f9eb96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6dc5dfef052d54a46bd6380e78e842a37fbe7ee1081550031eafebbab73219f"
    sha256 cellar: :any_skip_relocation, sonoma:        "305ad467187465e69a197b4145947c2cd7b887bd15a4abd8956991f4b8acb338"
    sha256 cellar: :any_skip_relocation, ventura:       "ef1263889f425cbf423ab4434c4b0f0fee8b89d93728724537a9d202ae62a1d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34f60849848ada5606778f00acb464f9f732ff765b68624a7581148dff4cddd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc56851beed007cfd88c8595bd6194a17a155e23cd0993b89c5adb7982dbf393"
  end

  depends_on "ghc@9.10" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "stack", "update"
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    man1.install Dir["hledger**.1"]
    info.install Dir["hledger**.info"]
    bash_completion.install "hledgershell-completionhledger-completion.bash" => "hledger"
  end

  test do
    system bin"hledger", "test"
    system bin"hledger-ui", "--version"
    system bin"hledger-web", "--test"
  end
end