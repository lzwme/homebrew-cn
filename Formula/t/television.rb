class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.10.8.tar.gz"
  sha256 "1a827a271101fede280075f9d53304051fca0bfbd68f7fd2a91d9dce7d07b2b8"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e0c74561902858914d98ce1037e039e13fb5c38c292f9e9a5d9e5c59533bdd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "714543ddf62c6f64473eed7d62439fd3588d31f0209e49ca18552f5ed63a2785"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68a34ab24ab7c96dec8c683b1d22156f433309a00136cc5f7b5bf95eebf0e41e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a8780ba77505da9a9ccf9e6b2a450b0156acab7e3017a56b09038b20db8d8a5"
    sha256 cellar: :any_skip_relocation, ventura:       "40a02e6fa96b2d8c34a8f00d35294e280087854b1706b993aa6ed6ee2784172a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffefc5654a5ed6e6beb0b32f0afad617aef8a01fc941c6e8ad22d50c7c0d6a63"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end