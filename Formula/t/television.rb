class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.10.6.tar.gz"
  sha256 "d316ddd82aa725e381f238aec190423c6dd1569b25697a3e318fef990205ade3"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efb4ec6d3c617c74132c571b30b90f5b0fdf381cda47cbb24dc589d990a336de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66240da2d0ade1fab5f0bd7dba96a2fdbe7a6ef8b801b2a291667802e908637"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db00ac18531db9db1857c92cab7f9ebf08fced3c6c4e91cd56189526f167bb1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d965b7ffdf183d189fae0495a3915e93b37a244e741abd2d40fe14d970a0568d"
    sha256 cellar: :any_skip_relocation, ventura:       "a322513b8aa7abf3e85a477ecf9bc80cd38cc74e41ed709eca0c91ce99e04498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba1d0a809ea63143dd2500f3b19f19fffba1dc7c964fcae2e434d80b510ad7e0"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end