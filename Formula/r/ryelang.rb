class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.0.86.tar.gz"
  sha256 "b72f9a7706bad5d51b90053233d46b094c728f9776a9baa6be818a83acc18470"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a111d151d802d71508fbbf1cda865c7633f86660a625e1ebf8982e5d83f562f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd059b9dcaf7135f63b98c67506c54c73f534b422684fbe8d8a084e00ba30134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99a35bd9256875d0d18cbf04944869319df1696fb3d6451b7c6c87790d1c85df"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb71ca1514bdbc933122e89a01a83dae30dbe5682edc54512f531c003ae495d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87bce56e4a26e12a37865d60b6d44e68104d14cb5c5890257eeba08b86f14d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1738697ddb32ddf8e76ff0022a0288d9b9a94522c08e51797184547412c956d5"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end