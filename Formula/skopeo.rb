class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://ghproxy.com/https://github.com/containers/skopeo/archive/v1.13.0.tar.gz"
  sha256 "65c90d5ba55a5075e56f9a4a5d96a46ca4c443f4cd2701c2eabb9592ba3460ce"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "07629c58cce4ea74c0cea781f352bf997d7f82e05bc5709e3433f57b435a801e"
    sha256 arm64_monterey: "5ed8af481333f8e004b948a1c9e4072b9d995c92d71151e6259bf83e38e63659"
    sha256 arm64_big_sur:  "ce1ce5564cf6a4b3937654715df73e59969542339175fa7efd551c0167a71d9b"
    sha256 ventura:        "daccffbf7963f482f76cffb4a5ff218efdf398dae3f2d88dedd7f70777d27ad7"
    sha256 monterey:       "63b57edd091224e4ed5daa3f53eca3f99d4f617093e777e0d013a846e60f4dc9"
    sha256 big_sur:        "d6c29af23b552bb2a5788ba209f06d706a04f8cf7b0b924ac5006090178575d1"
    sha256 x86_64_linux:   "6c1ea7389aed8c6b9ba06ebf690098f0ac25b8b804b4eae6857fd0d3e268adc0"
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