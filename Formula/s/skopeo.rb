class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https:github.comcontainersskopeo"
  url "https:github.comcontainersskopeoarchiverefstagsv1.15.2.tar.gz"
  sha256 "9d5e2163fe3bc0fc5d36d0e0e43e6e3cf26e12a855ae53e2aa4ddbe60acced3c"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "85263908dc07e9608d46b00dae420a7ce23f7399b0ef9d7da52ea120b127fc83"
    sha256 arm64_ventura:  "6a09383dc742b54fcbf06b6607649dc01cd59eb5a4adbc360b17161850a9ee86"
    sha256 arm64_monterey: "312864ee5c1930653318e948f48f5ed74ab56bb1c5a7d24fbd2757c7c70a6864"
    sha256 sonoma:         "97725530d05ad9bc29e7c60a7dbef9414f6dc380ad6139ac6d6dec3804f0cc12"
    sha256 ventura:        "04f362795bf605868b9bdfad9f72122e34134e551d36d35d205b6df5fdcada54"
    sha256 monterey:       "8ee35abde7ff59699b33358ee92b9cb7c2ec1e1ea9dc6944e88c6cec4e1c77b6"
    sha256 x86_64_linux:   "201486e469d199e9ec1c9a1ac51fa5e0d77a9277b212fad19709d5194c6b849f"
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

    system "go", "build", "-tags", buildtags, *std_go_args(ldflags:), ".cmdskopeo"
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