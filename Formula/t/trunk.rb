class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.18.7.tar.gz"
  sha256 "6d8ef3e02fefc537b85c0ae8eeb533475c7f46e8a4247156ac6677fb09718b5b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "648238cfbef285b7f9b6de64f4de967c2629b0c265b6e4c8f9791e34e3016aea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "042b493fbfc0ca553cc4d53281a0a74ed5f982a3b8286c54e213d5c0419db80e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3849d8b7f9732f71d5dc6160688ebd10d918b8ecf2034757ade1140141179c3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc32d86a1fe9363a6c5a651a83369be3be02b7017eea9b71ed0dbdb34915b670"
    sha256 cellar: :any_skip_relocation, ventura:        "e8236ff8656d76d66f66fca137314134d88e3bfa164e77a0ad43ac94acecbc6c"
    sha256 cellar: :any_skip_relocation, monterey:       "92edd32537a42dba790591c06a1646d9b151254eca08cd1f8c39b5931d270e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25450fdb04c359242a3967f789b121e6123797d861b62744ae8635034aa53368"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}trunk config show")
  end
end