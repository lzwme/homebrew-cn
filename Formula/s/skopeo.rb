class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https:github.comcontainersskopeo"
  url "https:github.comcontainersskopeoarchiverefstagsv1.14.0.tar.gz"
  sha256 "062ca24dcc106c3758e90a4af207b67166437ab71128bd33749b0414e0a42f79"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "1e38059439e585d3fca999b3bf1031590e6151fb0e4ec341a4d28aa1ad5d0c5f"
    sha256 arm64_ventura:  "d15e5c5d55c9900d9c4e3a8411611cd7dfaccc1c63d1067bec791d6db889a7b3"
    sha256 arm64_monterey: "75c5f3d70149e4fb002c16fddc37b28e97a1a2760634339c0b4d30ef089ba926"
    sha256 sonoma:         "6b8876891a5dff56bd80d5269d09a268dddec5a5a845c0c801a4a2ed2d7a1833"
    sha256 ventura:        "0686bf155b94815dc9f8fef1abfd322c3f80c398fb94567f975198ba83e24b55"
    sha256 monterey:       "42c0a37751cc5a6826c0ef7a59c46d8f2428047462ed965fba7d33c89c664680"
    sha256 x86_64_linux:   "09336203f9c537159af65395fe26286f91cd00d805f638617209aee49fe57809"
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