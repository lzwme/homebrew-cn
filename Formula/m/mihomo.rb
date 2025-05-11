class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https:wiki.metacubex.one"
  url "https:github.comMetaCubeXmihomoarchiverefstagsv1.19.6.tar.gz"
  sha256 "dec17f340decaa7971117ba908e39e4a9e311e8012dad9200bd517bdd405f1cf"
  license "GPL-3.0-or-later"
  head "https:github.comMetaCubeXmihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d80d373d9cd9fe1d302a865702de94b2bc8b248f9c847a127e7d0bda66594a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f4bf472eaa651f9e6811e8e31cf4b2e0d5dcfa8af7905c425da5e6fe02043ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf35e253f6a9eb8c9c963131dd4d2aefd5c771f61be799073e43eb47be476a22"
    sha256 cellar: :any_skip_relocation, sonoma:        "079866d1d1ab1b705cf1b00196165fbb514d74b2a2e965b4404a4e2383612bd6"
    sha256 cellar: :any_skip_relocation, ventura:       "47b4543764fbaad2699fd5e9b75ed8b3b5a934a49428f37345da72d97e37510d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8e0d28916ab714cd5bac83732035f0d66fe97376cdf9aa16b40a743483e871f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3752ace0dc9f84a660029046d503a4ae9a2fbe1d3516bd3cb26cfae62fde9e5b"
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