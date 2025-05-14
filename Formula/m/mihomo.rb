class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https:wiki.metacubex.one"
  url "https:github.comMetaCubeXmihomoarchiverefstagsv1.19.8.tar.gz"
  sha256 "47e38ea4220f5b84485b06d980ff06cc9a48cd7bd9bdf1236168adf728a99835"
  license "GPL-3.0-or-later"
  head "https:github.comMetaCubeXmihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e778993459c59f6503b6e5cf36a2510094f56e39563801f811a030b39b49b22e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "684a00e5f154a0dc54a34efc8860a144b67add97c026366479530cbe5855ebe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ad47220dc55097cae7ea5a0060dc21a15516ca5e9af00b4494940360a57b041"
    sha256 cellar: :any_skip_relocation, sonoma:        "b26d0e0a997d80a2df55f7d2638b0e389968229598948373f090cff06617d6c9"
    sha256 cellar: :any_skip_relocation, ventura:       "60d53ce49c24fca624a5e39cd1945e96a88a226cbff99312002b1287a7ee7e7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20e41714ba9bd2d6bb867f8b85da2a2f57e9ed5a84d52890989b5b4549883452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0df5d71a8aa56d7c8f1be92cc5614ac1c75d5c5c842c2c2aa43eef0f42aae71"
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