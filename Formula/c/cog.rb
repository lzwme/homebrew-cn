class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.9.10.tar.gz"
  sha256 "38bef8bd5e54a245ec12ed9418f9c3730c767361933f0c222f67ec2d981022b5"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4150962fdd4536d1cae595c2f432543c9113fc5935e80d62416595e3240d4383"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a2d0f6909afa7d8249cdfc1c7516791fc25e46f7991b4d91aba87960f940b1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea5e050131ed5d6d13c1bf84ee696773eed8ad84a59cea07f220f82099266bb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d21f1605513f9a3f711d1cd5f052e00526707a6adacd87cf138ae73990a1fe1d"
    sha256 cellar: :any_skip_relocation, ventura:        "bae497cedb4f59bbee9d8885771a0d607b1951b09f98d8ad4cf2b3bdafb68c69"
    sha256 cellar: :any_skip_relocation, monterey:       "69d385d7d614d3d68c9ba047a1c3f935ca4e0b1756ec3e3520aa90ee4bb16436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e65c5836a32d294540a098bc04542dcd812790e52410c9d4223493b972738066"
  end

  depends_on "go" => :build
  depends_on "python@3.12" => :build

  def install
    python3 = "python3.12"

    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath"pkgdockerfileembed").install buildpath.glob("cog-*.whl").first => "cog.whl"

    system "make", "install", "COG_VERSION=#{version}", "PYTHON=#{python3}", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}cog build 2>&1", 1)
  end
end