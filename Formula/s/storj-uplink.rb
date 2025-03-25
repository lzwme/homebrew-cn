class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.125.2.tar.gz"
  sha256 "8e3dccd6bf6f19abe92f8893741b9f1c251c6a863a82818f16f42e694b0c82f7"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy ifwhen
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91ebc8786166308511e585ae557ebda9f13821ee24a4e502b4a8c1b15d9ca7ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91ebc8786166308511e585ae557ebda9f13821ee24a4e502b4a8c1b15d9ca7ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91ebc8786166308511e585ae557ebda9f13821ee24a4e502b4a8c1b15d9ca7ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "de7f018779e995d4f8eae10e110f8a5345469bbef324d10d575d8629f0cdac7d"
    sha256 cellar: :any_skip_relocation, ventura:       "de7f018779e995d4f8eae10e110f8a5345469bbef324d10d575d8629f0cdac7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cabb2fdb1a66aa08f0225fff778cc14c5a9c9a95015cccacede6c6c1d17b389"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end