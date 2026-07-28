class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.2.57.tar.gz"
  sha256 "b39545e7eb1065d8a777e7f1f66bd177ff9bbe99b05b8865218fe32bc1e81fe0"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d09daa311fb12e0ccfe1afe3d5c04362a310431e855bc2391a26206eea58868a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a645a2e28a6a950ca4329fa3ff535ecbeff7e7f81f51e675f4059ca67392dd47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32be6b6e75da7ac26808d9f34c161d2a83f641277275186cfd7c040ff7db4e11"
    sha256 cellar: :any_skip_relocation, sonoma:        "78a3360de2268ea887a3c6bd86201bb3dfd7245452d0754fb0e40b904827e0d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0defb3f48a25d6e5b908e547c5dc20804c85b128bb8bfb10a137485c6cf06c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89a42ad80d6b5c1d21a5b54e026c66a196412ef1a920b2734583f36e77e0ec86"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[-X github.com/refaktor/rye/runner.Version=#{version}]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end