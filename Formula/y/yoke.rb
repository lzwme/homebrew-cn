class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.12.5",
      revision: "a0c8bdbcae945d402117b2f21b1f06a930798667"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "274dc7dc5f8773d75342883aa2f5bbe973c84a5fefa53a7dd5824d96876e5afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c25aa2600095fae32bffa43316b6854f5ccdee22675751747c60760c33c864dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bf43c585647026c85091b1248218415916e78e42884e8db857ebe0d4a845747"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d50d99fca4c829f53e5a16b1412451c46b96c495c55d970b22636a74aa893c"
    sha256 cellar: :any_skip_relocation, ventura:       "129926df54c4a05a8aa5e345ca941c2e5bc0ffcbde581ef317a3ec11fa3b974a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "303c9cae832c9b45d0568d2ad9c16a47e6c9d68f1c47bec5ad9a42ab331f4ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90859647f599334f7f16efa2e416e238dbe6c431ac1d76054184d447edd4c2c3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdyoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}yoke inspect 2>&1", 1)
  end
end