class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.101.0.tar.gz"
  sha256 "093ace8f58e2ef3b07a2cae8b21a7a6ff0a8dbff9dc8040954d8d12691634364"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2913d8720decc5fe4066909c48de1159677ca53603c165ae3c4c3a19f5776d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76c745f0ddb2ac9f9aa66de7df0fbbd8afdb0ace47bbf494a310da280c8565ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61110af345c659e230797a0b431eea78fcddc2adaddafb470678cb84d05c3e8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb6dbaa5e0b0b18d53a37b52d56bc05e3a906ea6ba6631a0c96675b3d37eae29"
    sha256 cellar: :any_skip_relocation, ventura:        "01c84c69b2a449126faf90f74c8f053a52dec336c76cb7d75436babb2afe7254"
    sha256 cellar: :any_skip_relocation, monterey:       "8bdcd96d11ccb3356da28585b5a129f07a29fd9054e66b178d54ee32f6151f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4287ef768c80abeecc68382f25c4a3f83d1bf391e239b0babe0a72d6653fefe9"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.comdigitaloceandoctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end