class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://ghproxy.com/https://github.com/containers/skopeo/archive/v1.13.1.tar.gz"
  sha256 "8e7195ff1c71c26f3e4b61d93239424b27293c2b3f9b8d67279b9ffd8adbbeca"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "a7b590af6c3ca917a32fb988a28a0696d61d96239e78a23287300d4d11f20ab8"
    sha256 arm64_monterey: "3667ce62ecbe7ce6d348f2ad6c9eb203af5021ce8d53a1ebe634ed753d1248e6"
    sha256 arm64_big_sur:  "255af10b7ccf519cc031895083c6fda774cb714f8c5b332b0d6054a4b8e502fb"
    sha256 ventura:        "262f82d52f8d81011872bded6001c2ebab93927bc79da63966664d2b53fc7cc4"
    sha256 monterey:       "84f2bb7aa4ddae6cdee48c4e49b36a36739a72c4761b7e26b47396ea9e79e493"
    sha256 big_sur:        "24c50b5931ec8e97051e40e851583fb39b43634fe22d79438cbb3a798c23526c"
    sha256 x86_64_linux:   "4ff333e3df7e2fa9e5a0a2689b60ff79702a7f325e38d959b587580bb902766f"
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
    ENV.append "CGO_FLAGS", Utils.safe_popen_read(Formula["gpgme"].opt_bin/"gpgme-config", "--cflags")

    buildtags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_tag.sh").chomp,
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libdm_tag.sh").chomp,
    ].uniq.join(" ")

    ldflag_prefix = "github.com/containers/image/v5"
    ldflags = %W[
      -X main.gitCommit=
      -X #{ldflag_prefix}/docker.systemRegistriesDirPath=#{etc}/containers/registries.d
      -X #{ldflag_prefix}/internal/tmpdir.unixTempDirForBigFiles=/var/tmp
      -X #{ldflag_prefix}/signature.systemDefaultPolicyPath=#{etc}/containers/policy.json
      -X #{ldflag_prefix}/pkg/sysregistriesv2.systemRegistriesConfPath=#{etc}/containers/registries.conf
    ]

    system "go", "build", "-tags", buildtags, *std_go_args(ldflags: ldflags), "./cmd/skopeo"
    system "make", "PREFIX=#{prefix}", "GOMD2MAN=go-md2man", "install-docs"

    (etc/"containers").install "default-policy.json" => "policy.json"
    (etc/"containers/registries.d").install "default.yaml"

    generate_completions_from_executable(bin/"skopeo", "completion")
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output

    # https://github.com/Homebrew/homebrew-core/pull/47766
    # https://github.com/Homebrew/homebrew-core/pull/45834
    assert_match(/Invalid destination name test: Invalid image name .+, expected colon-separated transport:reference/,
                 shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1))
  end
end