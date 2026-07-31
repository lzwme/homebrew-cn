class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.2.58.tar.gz"
  sha256 "7452c071962e43e409aee13f4e1acaafcce5fae44b8e9c1a10c4b5dc4e133682"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d75791587cf49cb908ee565c02ccb4d2d3e2736ea5ff697b6eb3223a1b91e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3a859d5d12aac87043f345f04b867c230c56b2b4f540dbe592f81422d37e718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c5d29b382ab670b602dd3cbd96b5136629a0d2412e87a29aceab43690617e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d6b792c1b9d166a172c626ae2549e871897e4e8c890fc2fd697273264183f5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47b770c77de79e09fd473e9479af07993cd3fed2e2626788faea6b3610edfa4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a10179ed271c1f10610d0d7da7fedfd11b495e6022872b0f86309d083bc0ab98"
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