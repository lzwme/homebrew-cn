class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https:github.comcontainersskopeo"
  url "https:github.comcontainersskopeoarchiverefstagsv1.18.0.tar.gz"
  sha256 "8a711db2bba3a357bebbbaf607ec731df6ea24c2d3cd9e0fef5e8fe9cefb154b"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "195bf2056940f30706d741fe96e90ca3ece2341b495362fc612add616dd6d59a"
    sha256 arm64_sonoma:  "1a007f92b40a5ad1ef3f1ff95540048206eaed2ab074e9abd469752e92f14aaa"
    sha256 arm64_ventura: "450b43b987dfeb5db843d9b51a49bc886dd13278b14da80b62dc68d7250781b2"
    sha256 sonoma:        "dc6f7ef86d7798c357873cf304fe5737425cafc37ba6e60996873155ccee98f2"
    sha256 ventura:       "26cea0fc22ddac9a843bce5d05873a278556b0b5111438394e69d9f49fb3075b"
    sha256 x86_64_linux:  "afdc1cc58b037b58f0e275ba196ad8b5bad1ccaff8a9aa4c7cf96e5fa402a144"
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
    ENV.append "CGO_FLAGS", Utils.safe_popen_read(Formula["gpgme"].opt_bin"gpgme-config", "--cflags")

    tags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hackbtrfs_tag.sh").chomp,
      Utils.safe_popen_read("hackbtrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hacklibsubid_tag.sh").chomp,
    ].uniq

    ldflag_prefix = "github.comcontainersimagev5"
    ldflags = %W[
      -X main.gitCommit=
      -X #{ldflag_prefix}docker.systemRegistriesDirPath=#{etc}containersregistries.d
      -X #{ldflag_prefix}internaltmpdir.unixTempDirForBigFiles=vartmp
      -X #{ldflag_prefix}signature.systemDefaultPolicyPath=#{etc}containerspolicy.json
      -X #{ldflag_prefix}pkgsysregistriesv2.systemRegistriesConfPath=#{etc}containersregistries.conf
    ]

    system "go", "build", *std_go_args(ldflags:, tags:), ".cmdskopeo"
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