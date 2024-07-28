class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv14.4.0.tar.gz"
  sha256 "5ebdf7ba5c1e0289439442a95cbf2c728f980d0fb7d2d32112b93a4b783ff3e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f387e99571f66ff8b8c526812ac6c2797566e13156887b0b78b0db77b8bda12a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e02bd6d1b998d45bf518606c1c87754d1b5dd529c0c6992f949a77d855d8aa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90d7a6e625dc4fc9c109b9182bb3d42246177d9a5912e3d84560f7730a58ee55"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fb3c4e4ba4f9e32538c1218f31348c254ba0e2a298726ee0f5cd3a3fac4afd8"
    sha256 cellar: :any_skip_relocation, ventura:        "db85ca1374f78c283cf91a72462127f352345a88fa02bfda1a25325106651ab6"
    sha256 cellar: :any_skip_relocation, monterey:       "d5579c6473e62e337ee93a7e5aace6feec36513d6b0c3e193596ec1e90e484d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "998dccba6c5232a9d9c160b0aaa8d0f5fad26c4c593be6e9c42f77c291010a28"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end