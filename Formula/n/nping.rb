class Nping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https:github.comhanshuaikangNping"
  url "https:github.comhanshuaikangNpingarchiverefstagsv0.2.6.tar.gz"
  sha256 "b502b05f701ddc82f8be41607ab8b5262ca9f9dc52f906c6216d9d69ce58e401"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a42842057bd29979c4ee93dc23484831f193f5c8ceca44f1da7622c905670aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "838003c2d8156e5ebf02bf01744f7951c6123144b8992da80ecae42cb450f826"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "408fd57fc65ea774f7d675a8ff6901e044542593dfad627df4bb09b75210703f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ad586ed8c84c023dea9d6ad33a682b5b463ab51427acfa76f141521103136bc"
    sha256 cellar: :any_skip_relocation, ventura:       "a372b4a60509e2164e5e1572b2ee58ea59cd7ea90262244520a3852314a91f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ae97e04ba85de54a105d81d52459f2c01a17b6c7bd2b3111a8f89fb5e39e6f7"
  end

  depends_on "rust" => :build

  conflicts_with "nmap", because: "both install `nping` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "nping v#{version}", shell_output("#{bin}nping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"nping", "--count", "2", "brew.sh"
  end
end