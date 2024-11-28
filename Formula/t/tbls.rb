class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.79.4.tar.gz"
  sha256 "9631c6c1e380eb81add74c5981eb1c328c3d28c118c48d7786ebcd5d173826dd"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2af6f5554daaf2c02695e8cdcbbdbfc6ab74bca3e18022a9f4a6b666e9dad4ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11ea075ce3a4ffa98d627983474b605a3b4fbe5d189258ab189b53b8f0aec5fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b62fc78a77c19b9e53d4df3b192ce4d58cdc8dabbc1e7b7645fdebf321609e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f67dac0a81bc127104bce479110b7466db83b185aabcca58027bc959b3b4755b"
    sha256 cellar: :any_skip_relocation, ventura:       "5d79209e53238f73fc71e40545dadc3a91938072131981edb3a600c3a9a82609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12dba274b1c2267dd70843ec7ba053232a0bad5fbf9f03912fddb3bb82128629"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end