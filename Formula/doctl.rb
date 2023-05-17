class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghproxy.com/https://github.com/digitalocean/doctl/archive/v1.95.0.tar.gz"
  sha256 "1b3d054fd18f2b4c424b0fd116ee298881f3954075194c6cbaf3bbdb03fdb22c"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43abb463223446e99b1fd677eb9c402acda44e4907de0abc493a94485ff35936"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43abb463223446e99b1fd677eb9c402acda44e4907de0abc493a94485ff35936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43abb463223446e99b1fd677eb9c402acda44e4907de0abc493a94485ff35936"
    sha256 cellar: :any_skip_relocation, ventura:        "f3dca5ecb1e562c9245e60460705ea58daed7641c7d5ec8deae6df35ef47dc37"
    sha256 cellar: :any_skip_relocation, monterey:       "f3dca5ecb1e562c9245e60460705ea58daed7641c7d5ec8deae6df35ef47dc37"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3dca5ecb1e562c9245e60460705ea58daed7641c7d5ec8deae6df35ef47dc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2f4b73d5ec516261d4feca97ad5e208eafd58550a3a0d2d9f27dc6bd7187332"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end