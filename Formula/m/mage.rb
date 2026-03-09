class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.16.0",
      revision: "69e6f824732575e57977f68f8f3dd78313d666e5"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc7a3a161b8620c4098e9459958996359d2414db32d93a98d3339e1650ae0010"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc7a3a161b8620c4098e9459958996359d2414db32d93a98d3339e1650ae0010"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc7a3a161b8620c4098e9459958996359d2414db32d93a98d3339e1650ae0010"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2b67b59c849c82196b5e8631504bbe8b2efaf0ad2ee18cf4d61e7da5bfeea92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bda7776df944c802818ecca7ffe744db260b2e305dadd64c1aa18afec03fbbf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a307d65c8ccb27c881c3335eabaea3dc92a17380e1da648bb6e7b3c190dcd9a4"
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