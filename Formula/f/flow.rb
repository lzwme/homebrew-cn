class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.216.1.tar.gz"
  sha256 "8e843429a29f35d13513a30963b6d2a3c05673d95d0be4b9f9c2b1f12c035578"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aad52f396be2403c173e231b2ccad2bf3208ce37b4f4bc9775aacfcec592a17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a33e8372d8802cf81e02a0aa3b5f9dfe5995b03291b8592a15964f8fbecc556"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10d507bbbd5cc691cfe92255a7039607408c2c92f8667bbf5aa2faeeac08fd98"
    sha256 cellar: :any_skip_relocation, ventura:        "184e157aae2366e929d9fc47fa8d0688996220479a33921ab4a16d27879bbf71"
    sha256 cellar: :any_skip_relocation, monterey:       "df5ff0cbc62432bfa133231cfd64ae48e73fdd8878e1f94264ed4f718a4655cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d2223f9a41b292e169a346987f8398347716bee1eb55551b363fee5cb1ae5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "578d0497c7d31e8d6058a7675c45e5ace98409bf80819c1b2e27b340d6bcefdd"
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