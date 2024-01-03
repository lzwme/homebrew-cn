class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.93.2.tar.gz"
  sha256 "a7741322eb3ddc8f4b77d2130f598e20aa5b8ca0f9c3b0a91ead8f97a7a0bf70"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6efa4e26aca61b19a18f637999bda52c44918e12fd3c9d7938a4cccd0caec611"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaea0c5a686ffce5a7f64b435873063119dd45f7d582561d6e7decaa2160f127"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b2471f78bb2fd9c4b7b5997575d6a813780e2fced58770bbe9f2b4b3e96e46b"
    sha256 cellar: :any_skip_relocation, sonoma:         "40462587da9811a107c6283c4a457edd5ad57237b3ce95e9f253de2a7c5a1e03"
    sha256 cellar: :any_skip_relocation, ventura:        "c7ef962ac587aa4dd26c25684d5a44086b381bcd05036af41e1e30b512bd92fe"
    sha256 cellar: :any_skip_relocation, monterey:       "eb363c7c0d5875b090e3a380baacefd771837624fc2ca65191638e498a8b8930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de0c2069ddafe483692a4eda4b596455de256d5003eb303a7974757352f28303"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end