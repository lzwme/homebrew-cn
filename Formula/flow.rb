class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.206.0.tar.gz"
  sha256 "89ee810309eee3affdd8f2dc890e58593a574360f08d7f0f2c451762ea91a06e"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05e24a3b0fad6729ac3716719c82fcfa987ec393917a139f61c5a290ca9b6ec3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af044ea1de60b78bfb8ad63502455ad151c5ccb8a842d97670cf89aa944f182"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50bcccadc114ccc1bea176d64f1f4b16ed00850a5ec50c351d064292424ef513"
    sha256 cellar: :any_skip_relocation, ventura:        "83772b98f82076a07a730b2317d8f08ee24dd399dde1054457ec24d22838e02f"
    sha256 cellar: :any_skip_relocation, monterey:       "2b2438fafef9341c10127ddacdd025d121f39cb009f68516b313ca510bf4a377"
    sha256 cellar: :any_skip_relocation, big_sur:        "499ac438df9ef0c6ec7c215ab05195ffde00c1a2c87a71029f986fb21d3e5b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa039e9b58d9129de2e82548dd22e107f804592295381a7c5e911a2700fa5fd5"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end