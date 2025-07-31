class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://ghfast.top/https://github.com/containers/skopeo/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "043e9f568440accf1aafca122a25c4d21441f16de49475192ec4abeef7430358"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_sequoia: "b7337fc7461fe07dd1c6e9c116407df06e03357aaa16dcc916bfea707fb1f24c"
    sha256 arm64_sonoma:  "01e67815ba97eae7038de368dd93151bef22ecc9962f83e452003018ecdd65c0"
    sha256 arm64_ventura: "8a39f2a48ee37ff54c03f2386d3c81d1b1a7f912037334aaac33568bdb333713"
    sha256 sonoma:        "cda9aa991fb9e6e368e3ab073bd6314b6494537f0cf0fd7089af99c1c98d721f"
    sha256 ventura:       "ebb9e29f52aa493183a234e57b7fda58d64bbf0b8c75b30e8b68e43d6642f5a5"
    sha256 arm64_linux:   "1b49db712b8d4bbc91e5b2eb90887737629745555ff45676cfe5b5a926810511"
    sha256 x86_64_linux:  "b9857fb374c271b293b29ef7d9303ca38fc71e98e78600ddacf5f3dd78e119be"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.safe_popen_read(Formula["gpgme"].opt_bin/"gpgme-config", "--cflags")

    tags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libsubid_tag.sh").chomp,
    ].uniq

    ldflag_prefix = "github.com/containers/image/v5"
    ldflags = %W[
      -X main.gitCommit=
      -X #{ldflag_prefix}/docker.systemRegistriesDirPath=#{etc}/containers/registries.d
      -X #{ldflag_prefix}/internal/tmpdir.unixTempDirForBigFiles=/var/tmp
      -X #{ldflag_prefix}/signature.systemDefaultPolicyPath=#{etc}/containers/policy.json
      -X #{ldflag_prefix}/pkg/sysregistriesv2.systemRegistriesConfPath=#{etc}/containers/registries.conf
    ]

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/skopeo"
    system "make", "PREFIX=#{prefix}", "GOMD2MAN=go-md2man", "install-docs"

    (etc/"containers").install "default-policy.json" => "policy.json"
    (etc/"containers/registries.d").install "default.yaml"

    generate_completions_from_executable(bin/"skopeo", "completion")
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect --no-creds docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output

    # https://github.com/Homebrew/homebrew-core/pull/47766
    # https://github.com/Homebrew/homebrew-core/pull/45834
    assert_match(/Invalid destination name test: Invalid image name .+, expected colon-separated transport:reference/,
                 shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1))
  end
end