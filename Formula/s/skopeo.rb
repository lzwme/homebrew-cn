class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://ghfast.top/https://github.com/containers/skopeo/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "f76eeddf697a3cc7a872e3077ab4d0fdbebe9f3c6171462e3e9feb84368b3fac"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "42a235a9010237e3b8c381c53338c0580ffebd66188409e39b7bd4ed4542f2b3"
    sha256               arm64_sequoia: "92c13c46dc6641cc2a45df17427731b29c71aa3a9819c837b3a11914afe56902"
    sha256               arm64_sonoma:  "63d438d8feac6d73502bdd1b93bc889c48a54e1ffe3b72920b2b2ea21287771e"
    sha256 cellar: :any, sonoma:        "6ce78007250925ec83c468f6d0c04bbbf78e858d75a2c4d30b2d1c41813c3d03"
    sha256               arm64_linux:   "c7b7b957b0fe14c9cac3a84e92265a7f6873673562f7859cc2d6583302188c18"
    sha256               x86_64_linux:  "73e7baa86798f4ee9680f332df3eb665bee222531f02aaca8e3e17cf08c505df"
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