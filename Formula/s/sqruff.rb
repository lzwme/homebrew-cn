class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "ef2b61edb1555ee41a4db4cc6669b4b8e3918aa212dee9fcc82c14f7b296e39b"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5787e1d14b265475d5d51cd9bfad62b92223d30273c1d61a4f9883581ed97e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20ab82683a468e579ee517f4fb9299c7add99f6bb200a1536ab2255d626061e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4405586fea6badac95281bc6234a3e86286b8ca88efa1e0b7c31dddb5de3019a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b55289f8fa52ca9dc9b7cc975c19affc38bb73a9379e675a5014307b9e06187"
    sha256 cellar: :any_skip_relocation, ventura:       "cece51dde274d412c5bd4aae0740a9189a560fbe8e620a31fb0517236e22cb1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7b8c484c1c748e850be51f13c9a74c485862d864c1005e2bb3c9d5cfff1a6e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1de7443384260d37b53a492d29c7deecb922c48cb8caf2d97305ed706b6edd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}/sqruff rules")

    (testpath/"test.sql").write <<~EOS
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    EOS

    output = shell_output("#{bin}/sqruff lint --format human #{testpath}/test.sql 2>&1")
    assert_match "All Finished", output
  end
end