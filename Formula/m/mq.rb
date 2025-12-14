class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "5bad2f232e233897ad55d86071828ef217f65152223e71dec2164d49eaf82b45"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61346ca0c2d04aa0c66336d28129eba6f87e7bb136f25876fb253001063a11d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad0ca7e918b0ee57e63e59dec1f8927a404196f2ef7a06c62c52cb245efb5233"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9908a4782792655458119496e9e74bf59cd3b3f03831814c1d7469188e8f2412"
    sha256 cellar: :any_skip_relocation, sonoma:        "66d1ab32730e8232daa022c9f77a61a22dcc979c23bb86c84726ec6bf6bb271f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b00c432a46108197136f0b8e5b63826bf6c853644468f5bcb6c91a15927a5a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92cb31c61032ebb9ff59556bba8ac67944516f0f29693dfc239b3e948f04b3a0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end