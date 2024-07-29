class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https:github.comcontainersskopeo"
  url "https:github.comcontainersskopeoarchiverefstagsv1.16.0.tar.gz"
  sha256 "fed91fd067605460ef33431163227471b1e85c8768203fc393345d6ffd645448"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "46bd7255d1252ef39be0fe9581cf50f479850be928c0bd8b442c140aa942511e"
    sha256 arm64_ventura:  "40ad70539098db8d4d4c59e640a0866f8faf5a1e21599d6bf38f25be2281584f"
    sha256 arm64_monterey: "62aa104f5d20d7a381dcfc896800bbac89c65833001c0bdfb9e78af7baebdb94"
    sha256 sonoma:         "c3893e8b17bc36854dec5637bc9763d93f414aa5f3f4410a1ce5cea7f44208d0"
    sha256 ventura:        "4047978d3dde13fa410cca2f85507ba02934a1a7a52903394ed12f8e865e5bcb"
    sha256 monterey:       "a1e39d8a6c36d0856560fcfa11fe9683af1d99d543fde87610619d2e46cdab65"
    sha256 x86_64_linux:   "c2f39f8df6478347b4aa23a1b88c7367d82d7f7530be7bf36335db0450361005"
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
      Utils.safe_popen_read("hacklibsubid_tag.sh").chomp,
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