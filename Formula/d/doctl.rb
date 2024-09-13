class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.114.0.tar.gz"
  sha256 "a19ab6a36f65ebf39786f79f3c53caadab508874f84fb5d701f04191c0b27408"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2391332a7d73c9f90fc32df67f305f863ffceb71b4dba922a68ef182961ecf30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2391332a7d73c9f90fc32df67f305f863ffceb71b4dba922a68ef182961ecf30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2391332a7d73c9f90fc32df67f305f863ffceb71b4dba922a68ef182961ecf30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2391332a7d73c9f90fc32df67f305f863ffceb71b4dba922a68ef182961ecf30"
    sha256 cellar: :any_skip_relocation, sonoma:         "26f8fa39d52aa2c5f5d8c7409aef142410703cbcc1328f67728a18453f78d202"
    sha256 cellar: :any_skip_relocation, ventura:        "26f8fa39d52aa2c5f5d8c7409aef142410703cbcc1328f67728a18453f78d202"
    sha256 cellar: :any_skip_relocation, monterey:       "26f8fa39d52aa2c5f5d8c7409aef142410703cbcc1328f67728a18453f78d202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fefeece44eadcae6f782eaed2ff7d72bafd966c5c3260c5588c083bd570db051"
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

    system "go", "build", *std_go_args(ldflags:), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end