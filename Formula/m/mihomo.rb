class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https:wiki.metacubex.one"
  url "https:github.comMetaCubeXmihomoarchiverefstagsv1.18.8.tar.gz"
  sha256 "2d4d4bac7832cea737557f7ea4fd09d12dee777ec37b6da26a1fa42c1dfdf962"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71c5bcfb6cd74315d59878da7aa24ca8149174aedd59e0a782a45d5c1f666ee8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3ac794e900ed1404e21ce27cd02cdee22f098390573a8ec5cec22d623b8edde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28a66c54edd68d64059eb618d386a1dc5c7cc259f93b4f73006b48dab6f28b73"
    sha256 cellar: :any_skip_relocation, sonoma:         "dde0570ee0c997ec950c704fa336cb37f8c0f437a73d9bb8f64afcd2c648d2da"
    sha256 cellar: :any_skip_relocation, ventura:        "07c113ea82716ff6f10a2713a68f738b8a53c82b71f6f65ce7b629e41844d4ac"
    sha256 cellar: :any_skip_relocation, monterey:       "f4f63215385bd74edf2f69d5e30ecd225e19dc87933845c503e556b4bbc8e10d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bcec64d61b0ccb78241287e14677cff56cc421061581a7e738ce5ff80283293"
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