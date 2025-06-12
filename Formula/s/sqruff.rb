class Sqruff < Formula
  desc "Fast SQL formatterlinter"
  homepage "https:github.comquarylabssqruff"
  url "https:github.comquarylabssqruffarchiverefstagsv0.26.6.tar.gz"
  sha256 "5fa252e2710ffb18c7c07ffffea298ff2cfe1117d4279259fd1704d8dd1c7c7a"
  license "Apache-2.0"
  head "https:github.comquarylabssqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6a95f0688e5757713198d087da0afa605f8b42345a40101e8d867ddf0016cb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "088bcdb2e69fc1a294db643bf15cff9ae879e0a04c0c2477ae26ac804e0c0984"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "030bb909a90937ac2e72240653adce26def21386ad0325453d82bac36019c448"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae19a7d9afab0fc6156ec37567c3dc484b8d885204ccc0c8f2b99db8d4054331"
    sha256 cellar: :any_skip_relocation, ventura:       "fab8dd697a0d1fe735e308ac950c34e86db423c04eb048978644ddc4cc4b995e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ef877720f5787e2a4973f08e2d74586767a7cba2dade1b0046c27c513dde143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd16e099ee993c9c6315df05f57c9fe695a1501a793a31908d9f5cc5d0a81bb7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "cratescli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}sqruff rules")

    (testpath"test.sql").write <<~EOS
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    EOS

    output = shell_output("#{bin}sqruff lint --format human #{testpath}test.sql 2>&1")
    assert_match "All Finished", output
  end
end