class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://ghfast.top/https://github.com/containers/skopeo/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "de96bfc2bb523c852af675ffdadd934484812ce190aa8620e1d5fd6c51442e25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a93a144e4d21454d330d20537a175192818eff12bd3bf39b24bcd9df59c3ef11"
    sha256 cellar: :any, arm64_sequoia: "4a4dec053c4455b697ad281764db577f65df8e38b6229b523c7a2b80f19e308e"
    sha256 cellar: :any, arm64_sonoma:  "f19eda35caa3f43719974c12b493e6b01a22daf429171a852fda8e7faaa7405d"
    sha256 cellar: :any, sonoma:        "a57bd1550d62257a16cbba71ed575978b1098f2b3767ae341aff61e0cc089d7d"
    sha256 cellar: :any, arm64_linux:   "ae5b682c693390a7130d47c4086fc4537390fb3ff95a488e05d8e50bd0ab22c6"
    sha256 cellar: :any, x86_64_linux:  "7afc74962f447ba96d1ace2fba34d88894549adf366ebadb5be7e35f3d94c31f"
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

    ldflag_prefix = "go.podman.io/image/v5"
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

    generate_completions_from_executable(bin/"skopeo", shell_parameter_format: :cobra)
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect --no-creds docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output

    expected = if OS.mac?
      "Error loading trust policy"
    else
      "Invalid destination name test"
    end
    assert_match expected, shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1)
  end
end