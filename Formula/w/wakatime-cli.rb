class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.88.4",
    revision: "343c15d1262c36bfeb42b2dfe63dbc0064e02012"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "825e788f008791eb73d1fa50ecd05091a5c0d2af1f803000b5c3464b9a59963c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "043782e5699f83f16611d12fe0e2eb3ce3ab40fa5edbbb0be7976588e7914e87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "072243caac0f1f8dad03e462c68bcf6ebaf57b32a780db2dcf74fe040ca4d43c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0f109a41b06c8ed5ddfa00518d4070722d9b41ddcad18d18e693377732a797c"
    sha256 cellar: :any_skip_relocation, ventura:        "b60e5e9539dc32b93fb6e31a93d0b0c8186ea842355ac966b549db4bfdf22fca"
    sha256 cellar: :any_skip_relocation, monterey:       "c233bf5d6008e206646965b7df3cdac3bdb0acc03207ff9758f08626404f50b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81d98603e8e1eb7b1b6b4c1bef3adabeacc3927d103a92ccda7eefa251559cca"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.comwakatimewakatime-clipkgversion.Arch=#{arch}
      -X github.comwakatimewakatime-clipkgversion.BuildDate=#{time.iso8601}
      -X github.comwakatimewakatime-clipkgversion.Commit=#{Utils.git_head(length: 7)}
      -X github.comwakatimewakatime-clipkgversion.OS=#{OS.kernel_name.downcase}
      -X github.comwakatimewakatime-clipkgversion.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end