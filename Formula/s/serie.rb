class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://ghfast.top/https://github.com/lusingander/serie/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "57a98e20db28a81b7551cd4843aeb92d441b205ce3046c1b5b0d93463653a0c2"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06eab19cde4b30ab40c249fe2c4f1087fe8b5ca7c142ea3ae5bbb1d10deada4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f376a0206df72e98a363538de5abe46d942dcc89749fb58c6dc8ac4347ad91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e901f90e4cbe00f0fa044aa169f1c7f01d1e9d95413ed3d0586ade748e68b4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "459427f425c778ecedc0d4f23dc52bcca643f3a14c5ed8853e344b35c83bcfb9"
    sha256 cellar: :any_skip_relocation, ventura:       "91fd2bc79a8ffabb8eab13ccd0a88ca2f4fdb9e31bcefa35bcd0cd82dbbee6f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e49908f1ffee60586227e2de7406ac91dad1a0076b0197b2300e1ec7ac0548e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be9d2fb7149347590f5838c3f455b98b9bae73c7001cd1c60dfe63cf566314a4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    # Fails in Linux CI with "failed to initialize terminal: ... message: \"No such device or address\" }"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end