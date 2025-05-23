class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https:wiki.metacubex.one"
  url "https:github.comMetaCubeXmihomoarchiverefstagsv1.19.9.tar.gz"
  sha256 "900ddee847f4dc35f2298ca3fea451a9bbb582557ce390198d73a29f4586813f"
  license "GPL-3.0-or-later"
  head "https:github.comMetaCubeXmihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00440610ff7933cd5a590383a49919f45e90dd0130a58dd25f9c462ff2f1e3f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "262e85d9e305210f1579404ff925cedf8fdd28b0ffa7467cf69bd1b8a25525de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b927b0c13bf6d3885a8f1bfe0c0b385a4dd2b5a79402ce6a8c068afd20c5695"
    sha256 cellar: :any_skip_relocation, sonoma:        "51ddd5c3b31f377531bbfcf4430d13200c269bf49f3b2e76bfcf48c3a6f14dd7"
    sha256 cellar: :any_skip_relocation, ventura:       "1381896eac0993aa2e067198873836be2757676a73e53e3eca5f5eb100f6e44c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5a34298f284267bc1eabf68bdf10a50be7dd1b67d33f2b4da18c631b306d854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f3e68fe9b456b86b9782ab6f12198b5f28b541f4b9cb4f46fedadb95216b09d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.commetacubexmihomoconstant.Version=#{version}"
      -X "github.commetacubexmihomoconstant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "with_gvisor")

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