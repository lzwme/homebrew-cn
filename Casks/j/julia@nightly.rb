cask "julia@nightly" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.13.0"
  sha256 :no_check

  url "https:julialangnightlies-s3.julialang.orgbinmacos#{arch}julia-latest-macos-#{arch}.dmg"
  name "Julia"
  desc "Programming language for technical computing"
  homepage "https:julialang.org"

  livecheck do
    url "https:raw.githubusercontent.comJuliaLangjuliarefsheadsmasterVERSION"
    regex(v?(\d+(?:\.\d+)+)i)
  end

  no_autobump! because: :requires_manual_review

  app "Julia-#{version.major_minor}.app"
  binary "#{appdir}Julia-#{version.major_minor}.appContentsResourcesjuliabinjulia", target: "julia-nightly"

  zap trash: "~.julia"
end