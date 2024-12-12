class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https:github.comkyu08fzf-make"
  url "https:github.comkyu08fzf-makearchiverefstagsv0.45.0.tar.gz"
  sha256 "275fafd5ed2d9e7f9d08af44f61259b7d57633c6039c3ac8a407e005530ed2c6"
  license "MIT"
  head "https:github.comkyu08fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d7d7a3ada84cadd31982e95348ca3464ca27501e70f4bde5ff7f5dfc1abd2cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afeb0867ed6668c0a35e07810866991634ec52e14da12a02e1f34dd848a4920d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23df792826aabe4781a8780a16dde68ceaa85951d41154a664674e29f7c54976"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a2c38cac3ab587b18b452f27ccb3f866996cdf1ed3bee2ad170a5625a2feff5"
    sha256 cellar: :any_skip_relocation, ventura:       "2800eb10834e3c36733ab8790e0a0de758bea381a92418a88c6a368ce9bb6255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa5aea44235903cf756c1a31e6a03a75b78705d1e4cdb770f249fc684ae169c3"
  end

  depends_on "rust" => :build
  depends_on "bat"

  # build patch for missing `yarn` in runtime, upstream pr ref, https:github.comkyu08fzf-makepull387
  patch do
    url "https:github.comkyu08fzf-makecommitee2b04a324bf3653a450025dcfea76fce9dd97db.patch?full_index=1"
    sha256 "ea5d7fff1409150f7f28701a444dcbce9e1e5a317665fde5eaacd86ef2e4ac3e"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fzf-make -v")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath"output.log"
      pid = spawn bin"fzf-make", [:out, :err] => output_log.to_s
      sleep 5
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end