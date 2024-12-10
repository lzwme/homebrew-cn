class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https:wiki.metacubex.one"
  url "https:github.comMetaCubeXmihomoarchiverefstagsv1.19.0.tar.gz"
  sha256 "9713035bd2c3553588cd9151574f70b6803dc90a4aa65b0506429376675da22a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4209011d6790f54956f4dd774addf4fb1b62dc0a7df806344363c1789f8860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c5cf7abf81c9b48083940bf2226d77436bba98938b6525a03d246edae3744c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bef7129bdd352d96785aa54323eee25dcbf6975b4b4a999f3e9f87b56ea7aa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "148c5f713d73c2a46a231b3c7c64425bf575131e50671c26653439a3a39f23e8"
    sha256 cellar: :any_skip_relocation, ventura:       "add97e2f0d19e9c3155f436b62d95902d4f2fe5f6e13424724c071a5a47e66f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64326b5bd67de968b78d838837fc18493d8d896170c718bc47ad61402431842b"
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