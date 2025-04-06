class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv18.3.0.tar.gz"
  sha256 "b2adafca9d0d97f711fa1fcdbcfa6e3bb64255938a80a9c8d70ecbdcf892051e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a52d88e427f873b811be855284616b64e6a52a5c4f66d611e7d10f7a22ca1cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a52d88e427f873b811be855284616b64e6a52a5c4f66d611e7d10f7a22ca1cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a52d88e427f873b811be855284616b64e6a52a5c4f66d611e7d10f7a22ca1cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c030b70111eb171833b8e56f576e6334bd09136bff9c9a85fe143f102c026c7b"
    sha256 cellar: :any_skip_relocation, ventura:       "c030b70111eb171833b8e56f576e6334bd09136bff9c9a85fe143f102c026c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe92d561c9c8c7811be3239c721a46985234a5d1ff4d60f0fc7446d095c5d302"
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