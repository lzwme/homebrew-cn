class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://github.com/garden-rs/garden"
  url "https://ghfast.top/https://github.com/garden-rs/garden/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "a172077d817eda235f6e91a894a892485c2b19a8313eb60abf7c550258676125"
  license "MIT"
  head "https://github.com/garden-rs/garden.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88d592302c28b8bfd9e0dc50dfe67279f2f7076a9051051cfe9c08f99207cafd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db2e5daec023fffc870f1737b86fa455a9936a579213e1280e2e82ec14557075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "342ef03e317fc9d05d12785ea64fb30100fd65bb58ce4c4c3c8fab849ff60419"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bc9dfd4fec2347eb516a8646c622db3a25e058592560d2f04b785f17f34be25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80454641e638137441808c79f9e29fd9e0e330546c4313f6a5bf1e40ea32fec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "063594a259087ca1b5ade40743f1a7288d1670df7447f9c1dc358b61b03d9eba"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "gui")
  end

  test do
    (testpath/"garden.yaml").write <<~EOS
      trees:
        current:
          path: ${GARDEN_CONFIG_DIR}
          commands:
            test: touch ${TREE_NAME}
      commands:
        test: touch ${filename}
      variables:
        filename: $ echo output
    EOS
    system bin/"garden", "-vv", "test", "current"
    assert_path_exists testpath/"current"
    assert_path_exists testpath/"output"
  end
end