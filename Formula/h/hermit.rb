class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "1f2376e5c59e7281714b8c09574dffc5de19c7f212f337e9674e033d8d945ee9"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb3dc02595b8be1c5ac4f4f49517e235901365c395490324c107d7e72024a6d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4004f18c61a1ab57afc46e712aa8ad7e7c2eeabeb63e8403ce2852797d1bcd4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c87619a70290ed628ef7c6116176c69491631df42d0f92fb57ac6c94aa6ff116"
    sha256 cellar: :any_skip_relocation, sonoma:        "3efd58de6ee88f05ced06d3342a0f5d0f32d7a3c9e3cd925b48aec98c9764866"
    sha256 cellar: :any_skip_relocation, ventura:       "a191f8168cb8d227efd7631c2bafb3c0bd6ce5458e15a47ed6c923cb093bf575"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02eafa85e7099491c8cb8430f98f89c062fe1fa7877680daa32866406ae9352a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361a02bc3a43a8f970cda1c5337607de549c839d68a418f7b61b7629deff67c9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end