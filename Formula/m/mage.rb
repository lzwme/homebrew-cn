class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.17.0",
      revision: "707313f6ee76e8547dd185dc3ef817dea3389429"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e6cc26c9cad24fbcc66e42d5c3c546e640161c6b78a1f6374355f68b7eac7f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e6cc26c9cad24fbcc66e42d5c3c546e640161c6b78a1f6374355f68b7eac7f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e6cc26c9cad24fbcc66e42d5c3c546e640161c6b78a1f6374355f68b7eac7f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd6b93b6d0f87b77ec64b074e029757f0fb545882f5a9b4d8564cf7acc3d2484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61032af0f06706ed801424fa1439f9ae882d78a51014c13607440c01d6f4738c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61b465adcc6c58f1e98b2d9677a95a7574b018586408df398c0f341ea8a1f9f8"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{time.iso8601}
      -X github.com/magefile/mage/mage.commitHash=#{Utils.git_short_head}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_path_exists testpath/"magefile.go"
  end
end