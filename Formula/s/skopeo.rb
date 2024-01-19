class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https:github.comcontainersskopeo"
  url "https:github.comcontainersskopeoarchiverefstagsv1.14.1.tar.gz"
  sha256 "b174ada87751ecd7f8e0e292d163c9b0c4a2172a6ba32e1725ae272c24f7f841"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "b173baf058fd70275ed1ce7e79b3a26a927e7cfc28752505f28e4855b7be67c0"
    sha256 arm64_ventura:  "57b49bb39c47552b3d91ef8815616956418cfecffbd58951a1869c08f373ab41"
    sha256 arm64_monterey: "38d81452ecf8047376e210ad5bea745f123857393b13392a97ff03cee9fd3c21"
    sha256 sonoma:         "28066fb5c2a735821432687b6b87cef6d15e20dff6b8ee0a86d15a8d9e6bdc31"
    sha256 ventura:        "aa90cef46498259d4a941b95649dea19bf487e3a499627895b59ba3e6a6f7f82"
    sha256 monterey:       "17db70c21d73c6e674a6d92568798f1b254bad359fa8e2be8835ae62403f024c"
    sha256 x86_64_linux:   "7fb345bc188d441ad6e3fda0b24a1eb064acf5a4c35511abfd1c3b9dafbcd85e"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkg-config" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.safe_popen_read(Formula["gpgme"].opt_bin"gpgme-config", "--cflags")

    buildtags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hackbtrfs_tag.sh").chomp,
      Utils.safe_popen_read("hackbtrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hacklibdm_tag.sh").chomp,
    ].uniq.join(" ")

    ldflag_prefix = "github.comcontainersimagev5"
    ldflags = %W[
      -X main.gitCommit=
      -X #{ldflag_prefix}docker.systemRegistriesDirPath=#{etc}containersregistries.d
      -X #{ldflag_prefix}internaltmpdir.unixTempDirForBigFiles=vartmp
      -X #{ldflag_prefix}signature.systemDefaultPolicyPath=#{etc}containerspolicy.json
      -X #{ldflag_prefix}pkgsysregistriesv2.systemRegistriesConfPath=#{etc}containersregistries.conf
    ]

    system "go", "build", "-tags", buildtags, *std_go_args(ldflags: ldflags), ".cmdskopeo"
    system "make", "PREFIX=#{prefix}", "GOMD2MAN=go-md2man", "install-docs"

    (etc"containers").install "default-policy.json" => "policy.json"
    (etc"containersregistries.d").install "default.yaml"

    generate_completions_from_executable(bin"skopeo", "completion")
  end

  test do
    cmd = "#{bin}skopeo --override-os linux inspect docker:busybox"
    output = shell_output(cmd)
    assert_match "docker.iolibrarybusybox", output

    # https:github.comHomebrewhomebrew-corepull47766
    # https:github.comHomebrewhomebrew-corepull45834
    assert_match(Invalid destination name test: Invalid image name .+, expected colon-separated transport:reference,
                 shell_output("#{bin}skopeo copy docker:alpine test 2>&1", 1))
  end
end