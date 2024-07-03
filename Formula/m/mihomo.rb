class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https:wiki.metacubex.one"
  url "https:github.comMetaCubeXmihomoarchiverefstagsv1.18.6.tar.gz"
  sha256 "b8f343a02e873d632fb488537f7d1bd2c63af1654075143678570ba848a45df5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32c1ebec20f8eb5d0b4fab8b1a019bdd8743579d80283c0e344a95f8bf6a5a0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e25de246a15c25e75cf1f3d0646c6e9e5fe7c18e10dd9d930c35bd2781b4201"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecdb0f0f92d8fa74a45665382264f308780a5f1cbef3fc2fba42151099dec69e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9513c6afff2c43183ca8f00abd8863116f6f70b9b1a2aca9594823056ad1683"
    sha256 cellar: :any_skip_relocation, ventura:        "e8707e123a01506eb558503a591f800eda4255deee59e6a35e634b783e5beb60"
    sha256 cellar: :any_skip_relocation, monterey:       "648517f1571dc2028edcae260f41e135ef7516a61cb83a3f9d0b4bf154e0c658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2a5504d1dcbd0e1e8a16ca6f03f5240ba86917640ca4d57af5d5132bf88dfbb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.commetacubexmihomoconstant.Version=#{version}"
      -X "github.commetacubexmihomoconstant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", "-tags", "with_gvisor", *std_go_args(ldflags:)

    (buildpath"config.yaml").write <<~EOS
      # Document: https:wiki.metacubex.oneconfig
      mixed-port: 7890
    EOS
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

    (testpath"mihomoconfig.yaml").write <<~EOS
      mixed-port: #{free_port}
    EOS
    system bin"mihomo", "-t", "-d", testpath"mihomo"
  end
end