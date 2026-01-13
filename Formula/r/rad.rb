class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://ghfast.top/https://github.com/amterp/rad/archive/refs/tags/v0.6.27.tar.gz"
  sha256 "1731f3e7026c1a39baf0c0c0c0ee6f2ea513ac1b6e0b1b3cc228ced8edf089d4"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71cb5e5bf27904a4d116483a31850d3a2e1f1eea99aa485041cccf200f7014ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bafedbca81b9c95371d1edef67ed9c50e3e209596f7a08f189cb468c822eda1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8202f5e34bd2b689cbd249d22bb3386cb83f52daa440367863cb9f6d200a762"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b068f593adce9cbe2fecb6edc667221a68b60a4aae9c9be8453038f5f3feea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b90d3cf19b6cad694e55b9ca63c78c1407700a92666ea60e485a60c345223d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31c8d174f5939b882f34027d3b9eed5fcb43e5223c9eff4ad39c89c5484a4218"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rad --version")

    (testpath/"test").write <<~SHELL
      #!/usr/bin/env rad

      args:
          times int = 1

      for _ in range(times):
          print("Hello, Homebrew!")
    SHELL
    chmod "+x", testpath/"test"

    assert_match "Hello, Homebrew!\nHello, Homebrew!", shell_output("#{testpath}/test 2")
  end
end