class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https:wiki.metacubex.one"
  url "https:github.comMetaCubeXmihomoarchiverefstagsv1.19.2.tar.gz"
  sha256 "8afa33b5eb9fc20e521a986be5e21908b53858e4b2350b56e0bf3495b740c4dc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d71020fc7736932c04d49e3af1d194dbb48d2d68ecc398320a1ec8397e9feac3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a0f5658453f04675fd2b2fb691d85c43a5154cd731a302f06b49475a90e77ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f1582b7e7811d2b23263fb59eeac46875a27dad32f88f0f48250e1239e7dc6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3909c78f46643b4e629b103d4025bfbce90a810250b5dec94bb7a7495e322ce1"
    sha256 cellar: :any_skip_relocation, ventura:       "479257808cfcaf2578a43132225bf09392328aa0b688da2b87c3949547c699e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b10063a9bc4d61628c58a1579d5efbd7a5c9ab96947ebe95fdb2aff1b0551c11"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.commetacubexmihomoconstant.Version=#{version}"
      -X "github.commetacubexmihomoconstant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", "-tags", "with_gvisor", *std_go_args(ldflags:)

    (buildpath"config.yaml").write <<~YAML
      # Document: https:wiki.metacubex.oneconfig
      mixed-port: 7890
    YAML
    pkgetc.install "config.yaml"
  end

  def caveats
    <<~EOS
      You need to customize #{etc}mihomoconfig.yaml.
    EOS
  end

  service do
    run [opt_bin"mihomo", "-d", etc"mihomo"]
    keep_alive true
    working_dir etc"mihomo"
    log_path var"logmihomo.log"
    error_log_path var"logmihomo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mihomo -v")

    (testpath"mihomoconfig.yaml").write <<~YAML
      mixed-port: #{free_port}
    YAML
    system bin"mihomo", "-t", "-d", testpath"mihomo"
  end
end