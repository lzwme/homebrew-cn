class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https:wiki.metacubex.one"
  url "https:github.comMetaCubeXmihomoarchiverefstagsv1.19.3.tar.gz"
  sha256 "47b78ceb8acab5a8c4d7da0b745f06becea4f8d4687d7a5b1985c0b1348e79c2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c590215338a4794a28e5b2070c87e259466386330b8f85f958cf38fd8b3ce70a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f2c92ec14a18d0a996ec662a4e25b354c882f52570403a8f0a3ac37f81bbac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fbb720ba84b13c9ff9b54c365db9d1d9025baa6257d75d9c3e1518a11881ae4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bda54acc5ce8a9679f240448e12f0f292698661236c97720270ac12f1aa2e020"
    sha256 cellar: :any_skip_relocation, ventura:       "bb105436e1188d5f8402913ed6933076af89797b5ae00f79b6679016861a9aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "317f42a85eb43f8c2ba6285954058d6b3f24d92b1cbb05576b3aafa3238bf211"
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