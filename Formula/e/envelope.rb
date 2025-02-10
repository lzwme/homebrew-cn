class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https:github.commattrighettienvelope"
  url "https:github.commattrighettienvelopearchiverefstags0.5.0.tar.gz"
  sha256 "9d4c65872526489a7d6209f349f29573bb10e6933be067716a8b91443059d872"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.commattrighettienvelope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2a08d38431570d61a185929893fd331c103a453c8a583a0ecbdfbc506b5e2f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1857ef18e2b0a6a07f7aa3d992b2ca1582010681e8bd3564fe494cea0e799a1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2db4a3aa299d2e5e35f41ccf1c7a57a1af67cdac6ccad11a60b9f78ac8033231"
    sha256 cellar: :any_skip_relocation, sonoma:        "77543c1032b551ffff697e897a77c77f85d42607290bca8c39879d5979a4d671"
    sha256 cellar: :any_skip_relocation, ventura:       "3e415157aea074673d7e15bee86cf4490c951417433594ae47341fc25b3acf47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5411baedd069ae214d84815542bf793eed542b70c34fea2c1675334cab20e9"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "manenvelope.1.md", "-o", "envelope.1"
    man1.install "envelope.1"
  end

  test do
    assert_equal "envelope #{version}", shell_output("#{bin}envelope --version").strip

    assert_match "error: envelope is not initialized in current directory",
      shell_output("#{bin}envelope list --sort date 2>&1", 1)

    system bin"envelope", "init"
    system bin"envelope", "add", "dev", "var1", "test1"
    system bin"envelope", "add", "dev", "var2", "test2"
    system bin"envelope", "add", "prod", "var1", "test1"
    system bin"envelope", "add", "prod", "var2", "test2"
    assert_match "dev\nprod", shell_output("#{bin}envelope list --sort date")
  end
end